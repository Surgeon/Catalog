class CompanyController < ApplicationController

  def show
    @company = Company.get_company_from_2gis(params[:id])
  end

end
