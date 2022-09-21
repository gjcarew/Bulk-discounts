require 'rails_helper'

RSpec.describe 'admin merchant index page' do

  before :each do
    names_array = {'gjcarew' => 22, 'stephenfabian' => 25, 'Rileybmcc' => 22, 'KevinT001' => 11}
    allow(GithubFacade).to receive(:commits).and_return(names_array)

    pull_requests_count = 3
    allow(GithubFacade).to receive(:pull_requests).and_return(pull_requests_count)

    @merchant1 = Merchant.create(name: "Robespierre the Second")
  end

  it 'can redirect to edit page from admin index' do
    # require "pry"; binding.pry
    visit '/admin/merchants'

    within(".merchant_#{@merchant1.id}") do
      click_on 'Edit'
    end

    expect(current_path).to eq("/admin/merchants/#{@merchant1.id}/edit")
  end

  it 'can fill fields, click submit and change merchant info' do
    visit "/admin/merchants/#{@merchant1.id}/edit"

      fill_in 'Name', with: 'Washington'
      click_on 'Submit'

    expect(current_path).to eq("/admin/merchants/#{@merchant1.id}")
    expect(page).to have_content("Washington")
  end

end
