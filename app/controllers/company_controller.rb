class CompanyController < ApplicationController

  def show
    @company = Company.get_company_from_2gis(params[:id])
    db_company = Company.add_company_to_database(@company)
    db_company.add_cross_links_to_company()
    @phrases = db_company.get_company_cross_links
  end

end
