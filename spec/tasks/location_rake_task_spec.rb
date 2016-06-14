require 'rails_helper'
require "rake"

describe "fix_locations:jobs" do
  # Rake Test Set Up
  let(:rake)         { Rake::Application.new}
  let(:task_name)    { "fix_location:fix_locations" }
  let(:task_path)    { "lib/tasks/one_off_tasks/fix_location" }
  subject            { rake[task_name] }

  def loaded_files_excluding_current_rake_file
    $".reject {|file| file == Rails.root.join("#{task_path}.rake").to_s }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], loaded_files_excluding_current_rake_file)

    Rake::Task.define_task(:environment)
  end

  let(:valid_location) { "Denver, CO" }
  let(:valid_tech1)    { "Ruby, JavaScript" }
  let(:valid_tech2)    { "PHP" }

  before(:all) do
    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.add_stub( "Ruby, JavaScript", [] )
    Geocoder::Lookup::Test.add_stub( "PHP", [] )

    Geocoder::Lookup::Test.add_stub(
    "Denver, CO", [
      {
        'latitude'     => 40.7143528,
        'longitude'    => -74.0059731,
       }
      ]
     )
  end

  it "will update job location with correct location" do
    create(:stackoverflow_job, title: "Junior Dev position (#{valid_tech1}) (#{valid_location})")

    expect(Job.all.last.old_location).to eq(nil)

    subject.invoke

    expect(Job.all.last.old_location).to eq("#{valid_location}")
  end

  it "will not overwrite job locations" do
    create(:stackoverflow_job, title: "Junior Dev position (#{valid_tech1}) (#{valid_location}) (#{valid_tech2})")

    expect(Job.all.last.old_location).to eq(nil)

    subject.invoke

    expect(Job.all.last.old_location).to eq("#{valid_location}")
  end

  it "will make location nil if no valid locations are present" do
    create(:stackoverflow_job, title: "Junior Dev position (#{valid_tech1}) (#{valid_tech2})",
                               old_location: "#{valid_tech1}")

    expect(Job.all.last.old_location).to eq("#{valid_tech1}")

    subject.invoke

    expect(Job.all.last.old_location).to eq(nil)
  end

  it "will not change location if no parentheses available in title" do
    create(:stackoverflow_job, title: "Junior Dev position",
                               old_location: "#{valid_tech1}")

    expect(Job.all.last.old_location).to eq("#{valid_tech1}")

    subject.invoke

    expect(Job.all.last.old_location).to eq("#{valid_tech1}")
  end
end
