require "rails_helper"

contract_fixture_files = "tmp/contracts/candidate_*.json"

privacy_policy_reponse_file = "tmp/contracts/privacy_policy.json"
degree_status_reponse_file = "tmp/contracts/degree_status.json"
teaching_subjects_reponse_file = "tmp/contracts/teaching_subjects.json"
countries_reponse_file = "tmp/contracts/countries.json"
uk_degree_grades_reponse_file = "tmp/contracts/uk_degree_grades.json"
initial_teacher_training_years_reponse_file = "tmp/contracts/initial_teacher_training_years.json"
retake_gcse_status_reponse_file = "tmp/contracts/retake_gcse_status.json"
qualification_types_reponse_file = "tmp/contracts/qualification_types.json"
education_phases_reponse_file = "tmp/contracts/education_phases.json"

# mocked reference data API definitions
latest_privacy_policy_api = "#{Rails.application.config.x.git_api_endpoint}/api/privacy_policies/latest"
specific_privacy_policy_api = "#{Rails.application.config.x.git_api_endpoint}/api/privacy_policies/0a203956-e935-ea11-a813-000d3a44a8e9"
privacy_policy_body = JSON.parse(File.read(privacy_policy_reponse_file))

degree_status_api = "#{Rails.application.config.x.git_api_endpoint}/api/types/qualification/degree_status"
degree_status_body = JSON.parse(File.read(degree_status_reponse_file))

teaching_subjects_api = "#{Rails.application.config.x.git_api_endpoint}/api/types/teaching_subjects"
teaching_subjects_body = JSON.parse(File.read(teaching_subjects_reponse_file))

countries_api = "#{Rails.application.config.x.git_api_endpoint}/api/types/countries"
countries_body = JSON.parse(File.read(countries_reponse_file))

uk_degree_grades_api = "#{Rails.application.config.x.git_api_endpoint}/api/types/qualification/uk_degree_grades"
uk_degree_grades_body = JSON.parse(File.read(uk_degree_grades_reponse_file))

education_phases_api = "#{Rails.application.config.x.git_api_endpoint}/api/types/candidate/preferred_education_phases"
education_phases_body = JSON.parse(File.read(education_phases_reponse_file))

retake_gcse_status_api = "#{Rails.application.config.x.git_api_endpoint}/api/types/candidate/retake_gcse_status"
retake_gcse_status_body = JSON.parse(File.read(retake_gcse_status_reponse_file))

initial_teacher_training_years_api = "#{Rails.application.config.x.git_api_endpoint}/api/types/candidate/initial_teacher_training_years"
initial_teacher_training_years_body = JSON.parse(File.read(initial_teacher_training_years_reponse_file))

qualification_types_api = "#{Rails.application.config.x.git_api_endpoint}/api/types/qualification/types"
qualification_types_body = JSON.parse(File.read(qualification_types_reponse_file))

signup_for_teacher_training_adviser_api_uri = "/api/teacher_training_adviser/candidates"
signup_for_teacher_training_adviser_api = "#{Rails.application.config.x.git_api_endpoint}#{signup_for_teacher_training_adviser_api_uri}"

def yes_no_options(option)
  case option
  when "Yes"
    222_750_000
  when "No"
    222_750_001
  else
    option
  end
end

def primary_secondary_options(option)
  case option
  when "Primary"
    222_750_000
  when "Secondary"
    222_750_001
  else
    option
  end
end

# step definitions

def start_sign_up_wizard
  visit "/"

  expect(page).to have_text "Start now"
  click_link "Start now"
end

def enter_personal_information(first_name, surname, email)
  expect(page).to have_text "First name"
  fill_in "First name", with: first_name

  expect(page).to have_text "Surname"
  fill_in "Surname", with: surname

  expect(page).to have_text "Email address"
  fill_in "Email address", with: email

  click_button "Continue"
end

def answer_returning_to_teaching_query(returning)
  expect(page).to have_text "Are you returning to teaching?"

  choose returning

  click_button "Continue"
end

def answer_teacher_reference_number_query(has_trn)
  expect(page).to have_text "Do you have your previous teacher reference number?"

  choose has_trn

  click_button "Continue"
end

def enter_teacher_reference_number(trn)
  expect(page).to have_text "What is your previous teacher reference number?"

  fill_in "Teacher reference number (optional).", with: trn

  click_button "Continue"
end

def enter_previous_teaching_subject(subject_id)
  expect(page).to have_text "Which main subject did you previously teach?"

  select subject_id, from: "Which main subject did you previously teach?"

  click_button "Continue"
end

def enter_subject_to_teach(subject_name)
  expect(page).to have_text "Which subject would you like to teach if you return to teaching?"

  choose subject_name

  click_button "Continue"
end

def enter_returner_details(candidate)
  answer_returning_to_teaching_query candidate["Returner"]

  if candidate["Returner"] == "Yes"
    answer_teacher_reference_number_query candidate["Has previous teacher reference number"]
    enter_teacher_reference_number candidate["Teacher Ref Number (TRN)"] if candidate["Has previous teacher reference number"] == "Yes"

    enter_previous_teaching_subject candidate["Previous main subject"]

    enter_subject_to_teach candidate["Return to subject"]
  end
end

def enter_subject_interested_to_teach(subject_name)
  expect(page).to have_text "Which subject are you interested in teaching?"

  select subject_name, from: "Which subject are you interested in teaching?"

  click_button "Continue"
end

def answer_has_degree_query(has_degree)
  expect(page).to have_text "Do you have a degree?"

  choose has_degree

  click_button "Continue"
end

def enter_degree_subject(degree_subject)
  expect(page).to have_text "What subject is your degree?"

  select degree_subject, from: "What subject is your degree?"

  click_button "Continue"
end

def enter_degree_class(degree_class)
  expect(page).to have_text "Which class is your degree?"

  select degree_class, from: "Which class is your degree?"

  click_button "Continue"
end

def enter_predicted_degree_class(degree_class)
  expect(page).to have_text "What degree class are you predicted to get?"

  select degree_class, from: "What degree class are you predicted to get?"

  click_button "Continue"
end

def enter_study_year(study_year)
  expect(page).to have_text "In which year are you studying?"

  choose study_year

  click_button "Continue"
end

def enter_degree_details(candidate)
  answer_has_degree_query candidate["Degree"]

  if candidate["Degree"] == "I'm studying for a degree"
    enter_study_year candidate["Study year"]
    enter_degree_subject candidate["Degree subject"]
    enter_predicted_degree_class candidate["Degree class"]
  end

  if candidate["Degree"] == "Yes"
    enter_degree_subject candidate["Degree subject"]
    enter_degree_class candidate["Degree class"]
  end
end

def enter_teaching_stage_details(teaching_stage)
  expect(page).to have_text "Which stage are you interested in teaching?"

  choose teaching_stage

  click_button "Continue"
end

def answer_gcse_maths_english_query(has_maths_english)
  expect(page).to have_text "Do you have grade 4 (C) or above in English and maths GCSEs, or equivalent?"

  choose has_maths_english

  click_button "Continue"
end

def answer_retake_gcse_maths_english_query(will_retake)
  expect(page).to have_text "Are you planning to retake either English or maths (or both) GCSEs, or equivalent?"

  choose will_retake

  click_button "Continue"
end

def answer_gcse_science_query(has_science)
  expect(page).to have_text "Do you have grade 4 (C) or above in GCSE science, or equivalent?"

  choose has_science

  click_button "Continue"
end

def answer_retake_gcse_science_query(will_retake)
  expect(page).to have_text "Are you planning to retake your science GCSE?"

  choose will_retake

  click_button "Continue"
end

def enter_gcse_science_details(candidate)
  answer_gcse_science_query candidate["Grade 4 Science"]

  if candidate["Grade 4 Science"] == "No"
    answer_retake_gcse_science_query candidate["Retake science"]
  end
end

def enter_gcse_maths_english_details(candidate)
  answer_gcse_maths_english_query candidate["Grade 4 English and Maths"]

  if candidate["Grade 4 English and Maths"] == "No"
    answer_retake_gcse_maths_english_query candidate["Retake maths or english"]
  end
end

def enter_gcse_qualification_details(candidate)
  enter_gcse_maths_english_details candidate
  enter_gcse_science_details candidate unless candidate["Stage of Interest"] == "Secondary"
end

def enter_training_start_details(candidate)
  expect(page).to have_text "When do you want to start your teacher training?"

  select candidate["Desired start"], from: "When do you want to start your teacher training?"

  click_button "Continue"
end

def enter_date_of_birth(dob)
  expect(page).to have_text "Enter your date of birth"

  date_of_birth = Date.parse(dob)

  fill_in "Day", with: date_of_birth.day.to_s.rjust(2, "0")
  fill_in "Month", with: date_of_birth.month.to_s.rjust(2, "0")
  fill_in "Year", with: date_of_birth.year.to_s.rjust(4, "0")

  click_button "Continue"
end

def enter_uk_or_overseas(uk_or_overseas)
  expect(page).to have_text "Where do you live?"

  choose uk_or_overseas

  click_button "Continue"
end

def enter_address(address_line_1, address_line_2, city, postcode)
  expect(page).to have_text "What is your address?"

  fill_in "Address line 1 *", with: address_line_1
  fill_in "Address line 2", with: address_line_2
  fill_in "Town or City *", with: city
  fill_in "Postcode *", with: postcode

  click_button "Continue"
end

def enter_uk_telephone(telephone)
  expect(page).to have_text "What is your telephone number?"

  fill_in "UK telephone number (optional)", with: telephone

  click_button "Continue"
end

def choose_country(country)
  expect(page).to have_text "Which country do you live in?"

  select country, from: "Which country do you live in?"

  click_button "Continue"
end

def enter_overseas_telephone(telephone)
  expect(page).to have_text "What is your telephone number?"

  fill_in "Overseas telephone number (optional)", with: telephone

  click_button "Continue"
end

def enter_uk_address(candidate)
  enter_address candidate["Address line 1"], candidate["Address line 2"], candidate["Town or city"], candidate["Postcode"]
  enter_uk_telephone candidate["Telephone"]
end

def enter_overseas_address(candidate)
  choose_country candidate["Country"]
  enter_overseas_telephone candidate["Telephone"]
end

def enter_where_lives(candidate)
  enter_uk_or_overseas candidate["Where live"]
  enter_uk_address candidate                  if candidate["Where live"] == "UK"
  enter_overseas_address candidate            if candidate["Where live"] == "Overseas"
end

def check_answers(candidate)
  expect(page).to have_text "Check your answers before you continue"

  expect(page).to have_text "Name #{candidate['First Name']} #{candidate['Surname']}"

  date_of_birth = Date.parse(candidate["Date of Birth"])
  expect(page).to have_text "Date of birth #{date_of_birth.day.to_s.rjust(2, '0')} #{date_of_birth.month.to_s.rjust(2, '0')} #{date_of_birth.year.to_s.rjust(4, '0')}"
  expect(page).to have_text "Email\n#{candidate['Email']}"
  expect(page).to have_text "Are you returning to teaching? #{candidate['Returner']}"

  if candidate["Returner"] == "Yes"
    expect(page).to have_text "What is your previous teacher reference number? #{candidate['Teacher Ref Number (TRN)']}"
    expect(page).to have_text "Which main subject did you previously teach? #{candidate['Previous main subject']}"
    expect(page).to have_text "Which subject would you like to teach if you return to teaching?\n#{candidate['Return to subject']}"
  end

  expect(page).to have_text "Where do you live? #{candidate['Where live']}"
  if candidate["Where live"] == "UK"
    expect(page).to have_text "Address #{candidate['Address line 1']}#{candidate['Address line 2']}#{candidate['Town or city']}#{candidate['Postcode']}"
    expect(page).to have_text "Telephone #{candidate['Telephone']}"
  else
    expect(page).to have_text "Which country do you live in?\n#{candidate['Country']}"
    expect(page).to have_text "Telephone\n#{candidate['Telephone']}"
  end

  click_button "Continue"
end

def skip_check_answers(candidate)
  expect(page).to have_text "Check your answers before you continue"

  click_button "Continue"
end

def accept_the_privacy_policy
  expect(page).to have_text "Read and accept the privacy policy"

  check "Accept the privacy policy"

  click_button "Continue"
end

RSpec.feature "Dependency contracts", :vcr, type: :feature do
  before do
    stub_request(:get, latest_privacy_policy_api)
      .to_return(body: JSON.generate(privacy_policy_body), headers: {
        "content-type": "application/json; charset=utf-8",
      })

    stub_request(:get, specific_privacy_policy_api)
      .to_return(body: JSON.generate(privacy_policy_body), headers: {
        "content-type": "application/json; charset=utf-8",
      })

    stub_request(:get, degree_status_api)
    .to_return(body: JSON.generate(degree_status_body), headers: {
      "content-type": "application/json; charset=utf-8",
    })

    stub_request(:get, teaching_subjects_api)
      .to_return(body: JSON.generate(teaching_subjects_body), headers: {
        "content-type": "application/json; charset=utf-8",
      })

    stub_request(:get, countries_api)
      .to_return(body: JSON.generate(countries_body), headers: {
        "content-type": "application/json; charset=utf-8",
      })

    stub_request(:get, uk_degree_grades_api)
      .to_return(body: JSON.generate(uk_degree_grades_body), headers: {
        "content-type": "application/json; charset=utf-8",
      })

    stub_request(:get, education_phases_api)
      .to_return(body: JSON.generate(education_phases_body), headers: {
        "content-type": "application/json; charset=utf-8",
      })

    stub_request(:get, retake_gcse_status_api)
      .to_return(body: JSON.generate(retake_gcse_status_body), headers: {
        "content-type": "application/json; charset=utf-8",
      })

    stub_request(:get, initial_teacher_training_years_api)
      .to_return(body: JSON.generate(initial_teacher_training_years_body), headers: {
        "content-type": "application/json; charset=utf-8",
      })

    stub_request(:get, qualification_types_api)
      .to_return(body: JSON.generate(qualification_types_body), headers: {
        "content-type": "application/json; charset=utf-8",
      })

    stub_request(:post, signup_for_teacher_training_adviser_api)
      .to_return(headers: {
        "content-type": "application/json; charset=utf-8",
      })
  end

  # create fixture data grouped by Persona
  personas = {}
  Dir.glob(contract_fixture_files) do |filename|
    data = JSON.parse(File.read(filename))
    data["filename"] = File.basename(filename)

    next if data["Persona"] == "--" || data["Final Journey Status"] != "COMPLETE"

    # add the candidate to the correct Persona list
    personas[data["Persona"]] = personas[data["Persona"]] || []
    personas[data["Persona"]].push data
  end

  personas.each do |persona, candidates|
    feature "As a #{persona}" do
      candidates.each do |candidate|
        scenario "Someone can sign up for a Teacher Training Advisor with profile defined by [#{candidate['filename']}]" do
          start_sign_up_wizard

          enter_personal_information candidate["First Name"], candidate["Surname"], candidate["Email"]

          enter_returner_details candidate

          if candidate["Returner"] == "No"
            enter_degree_details candidate
            enter_teaching_stage_details candidate["Stage of Interest"]
            enter_gcse_qualification_details candidate

            enter_subject_interested_to_teach candidate["Interested subject"] if candidate["Stage of Interest"] == "Secondary"

            if page.has_content?("Which subject are you interested in teaching?")
              click_button "Continue"
            end

            enter_training_start_details candidate
          end

          enter_date_of_birth candidate["Date of Birth"]

          enter_where_lives candidate

          skip_check_answers candidate

          request = {}
          WebMock.after_request do |request_signature, _|
            if request_signature.uri.to_s.include? signup_for_teacher_training_adviser_api_uri
              request = JSON.parse(request_signature.body)
            end
          end

          accept_the_privacy_policy

          expect(request).to eql candidate["apiSubmission"]
        end
      end
    end
  end
end
