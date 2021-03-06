require 'spec_helper'

describe Spaceship::Tunes::Tester do
  before { Spaceship::Tunes.login }

  let(:client) { Spaceship::AppSubmission.client }
  let (:app) { Spaceship::Application.all.first }

  it "raises an error when using the base class" do
    expect {
      Spaceship::Tunes::Tester.all
    }.to raise_error "You have to use a subclass: Internal or External"
  end

  describe "Receiving existing testers" do
    it "Internal Testers" do
      testers = Spaceship::Tunes::Tester::Internal.all
      expect(testers.count).to eq(2)
      t = testers[1]
      expect(t.class).to eq(Spaceship::Tunes::Tester::Internal)

      expect(t.tester_id).to eq("1d167b89-13c5-4dd8-b988-7a6a0190f774")
      expect(t.email).to eq("felix@sunapps.net")
      expect(t.first_name).to eq("Felix")
      expect(t.last_name).to eq("Krause")
      expect(t.devices).to eq([{"model"=>"iPhone 6", "os"=>"iOS", "osVersion"=>"8.3", "name"=>nil}])
    end

    it "External Testers" do
      testers = Spaceship::Tunes::Tester::External.all
      expect(testers.count).to eq(2)
      t = testers[0]
      expect(t.class).to eq(Spaceship::Tunes::Tester::External)

      expect(t.tester_id).to eq("1d167b89-13c5-4dd8-b988-7a6a0190faaa")
      expect(t.email).to eq("private@krausefx.com")
      expect(t.first_name).to eq("Detlef")
      expect(t.last_name).to eq("Müller")
      expect(t.devices).to eq([{"model"=>"iPhone 6", "os"=>"iOS", "osVersion"=>"8.3", "name"=>nil}])
    end
  end

  describe "Receiving existing testers from an app" do
    it "Internal Testers" do
      testers = app.internal_testers
      expect(testers.count).to eq(1)
      t = testers.first
      expect(t.class).to eq(Spaceship::Tunes::Tester::Internal)

      expect(t.tester_id).to eq("1d167b89-13c5-4dd8-b988-7a6a0190f774")
      expect(t.email).to eq("felix@sunapps.net")
      expect(t.first_name).to eq("Felix")
      expect(t.last_name).to eq("Krause")
      expect(t.devices).to eq([])
    end
  end

  describe "Last Install information" do
    it "pre-fills this information correctly" do
      tester = Spaceship::Tunes::Tester::Internal.all[1]
      expect(tester.latest_install_app_id).to eq(794902327)
      expect(tester.latest_install_date).to eq(1427565638420)
      expect(tester.latest_installed_build_number).to eq("1")
      expect(tester.latest_installed_version_number).to eq("0.9.14")
    end
  end

  # describe "invite testers to an existing app" do
  #   it "invite all users to an app" do
  #     app.add_all_testers!
  #   end
  # end
end
