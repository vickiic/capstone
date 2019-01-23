require "application_system_test_case"

class HeartratesTest < ApplicationSystemTestCase
  setup do
    @heartrate = heartrates(:one)
  end

  test "visiting the index" do
    visit heartrates_url
    assert_selector "h1", text: "Heartrates"
  end

  test "creating a Heartrate" do
    visit heartrates_url
    click_on "New Heartrate"

    fill_in "Device", with: @heartrate.device
    fill_in "Time", with: @heartrate.time
    fill_in "Value", with: @heartrate.value
    click_on "Create Heartrate"

    assert_text "Heartrate was successfully created"
    click_on "Back"
  end

  test "updating a Heartrate" do
    visit heartrates_url
    click_on "Edit", match: :first

    fill_in "Device", with: @heartrate.device
    fill_in "Time", with: @heartrate.time
    fill_in "Value", with: @heartrate.value
    click_on "Update Heartrate"

    assert_text "Heartrate was successfully updated"
    click_on "Back"
  end

  test "destroying a Heartrate" do
    visit heartrates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Heartrate was successfully destroyed"
  end
end
