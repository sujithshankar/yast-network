#!/usr/bin/env rspec

ENV["Y2DIR"] = File.expand_path("../../src", __FILE__)

require "yast"

module Yast
  extend Yast::I18n
  Yast::textdomain "network"

  import "SuSEFirewall4Network"
  import "SuSEFirewallProposal"
  import "WFM"

  describe "FirewallStage1ProposalClient" do
    describe "MakeProposal" do

      before(:each) do
        # Ensure a fixed proposal
        SuSEFirewallProposal.SetChangedByUser(true)
        SuSEFirewall4Network.SetSshEnabled1stStage(true)
      end

      let(:proposal) {
        Yast::WFM.CallFunction("firewall_stage1_proposal", ["MakeProposal"])["preformatted_proposal"]
      }
      let(:ssh_string) {
        Yast::_("SSH port will be open (<a href=\"%s\">block</a>)") % "firewall--disable_ssh_port_in_proposal"
      }

      context "when firewall is enabled" do
        before { SuSEFirewall4Network.SetEnabled1stStage(true) }

        it "displays ssh port settings" do
          expect(proposal).to include ssh_string
        end
      end

      context "when firewall is disabled" do
        before { SuSEFirewall4Network.SetEnabled1stStage(false) }

        it "hides ssh port settings" do
          expect(proposal).not_to include ssh_string
        end
      end
    end
  end
end
