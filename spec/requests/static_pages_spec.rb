require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) } # тут использую хелпер в spec/requests
  end

  describe "Home page" do
    before { visit root_path }

    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem")
        FactoryGirl.create(:micropost, user: user, content: "Ipsum")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end

  end

  describe "Help page" do
    before { visit help_path }

    it { should have_selector('h1', :text => 'Help') }
    it { should have_title("#{base_title} | Help") } # а тут опрееленную переменную,
                                                     # методом let
  end

  describe "About page" do
    before { visit about_path }

    it { should have_selector('h1', :text => 'About Us') }
    it { should have_title("#{base_title} | About Us") }

  end

  describe "Contact" do
    before { visit contact_path }

    it { should have_selector('h1', :text => 'Contact') }
    it { should have_title("#{base_title} | Contact") }

  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    should have_title(full_title('About Us'))
    click_link "Help"
    should # fill in
    click_link "Contact"
    should # fill in
    click_link "Home"
    click_link "Sign up now!"
    should # fill in
    click_link "sample app"
    should # fill in
  end

end