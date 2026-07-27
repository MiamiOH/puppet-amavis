# frozen_string_literal: true

require 'spec_helper'

describe 'amavis' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile }

      context 'with default parameters' do
        it 'installs the correct Amavis package' do
          if facts[:os]['family'] == 'RedHat'
            is_expected.to contain_package('amavis').with(
              ensure: 'latest',
              alias: 'amavis'
            )
          else
            is_expected.to contain_package('amavisd-new').with(
              ensure: 'latest',
              alias: 'amavis'
            )
          end
        end

        it 'installs spamassassin by default' do
          is_expected.to contain_package('spamassassin').with(
            ensure: 'latest'
          )
        end

        it 'creates the amavis exec resource' do
          is_expected.to contain_exec('amavis').with(
            command: 'echo "amavis packages are installed"',
            path: ['/usr/sbin', '/bin', '/usr/bin', '/sbin'],
            refreshonly: true,
            logoutput: true
          )
        end

        it 'ensures amavisd service is running' do
          is_expected.to contain_service('amavisd').with(
            ensure: 'running'
          )
        end
      end

      context 'when spamassassin is disabled' do
        let(:params) do
          {
            spamassassin: false
          }
        end

        it 'does not install spamassassin' do
          is_expected.not_to contain_package('spamassassin')
        end
      end

      context 'when package versions are customized' do
        let(:params) do
          {
            package_ensure: 'present',
            spamassassin_ensure: 'present'
          }
        end

        it 'uses the requested Amavis package version' do
          if facts[:os]['family'] == 'RedHat'
            is_expected.to contain_package('amavis').with(
              ensure: 'present'
            )
          else
            is_expected.to contain_package('amavisd-new').with(
              ensure: 'present'
            )
          end
        end

        it 'uses the requested SpamAssassin package version' do
          is_expected.to contain_package('spamassassin').with(
            ensure: 'present'
          )
        end
      end
    end
  end
end