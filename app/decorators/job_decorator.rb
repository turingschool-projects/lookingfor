class JobDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  delegate_all

  def decorated_title
    title.titleize
  end

  def company_name
    company ? company.name : 'N/A'
  end

  def tech_names
    technologies.map { |raw_tech| raw_tech.name } if technologies
  end

  def decorated_date
    posted_date.strftime('%B %e, %Y')
  end
end