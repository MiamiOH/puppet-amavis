# frozen_string_literal: true

require 'spec_helper'

describe 'amavis::config' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile }

      it 'includes the amavis class' do
        is_expected.to contain_class('amavis')
      end

      it 'creates the amavis configuration file' do
        is_expected.to contain_file('/etc/amavisd/amavisd.conf').with(
          ensure: 'file',
          notify: 'Service[amavisd]',
          require: 'Exec[amavis]'
        )
      end

      context 'with default parameters' do
        it 'uses default virus destiny' do
          is_expected.to contain_file('/etc/amavisd/amavisd.conf')
            .with_content(%r{D_DISCARD})
        end

        it 'sets default max servers' do
          is_expected.to contain_file('/etc/amavisd/amavisd.conf')
            .with_content(%r{2})
        end
      end

      context 'with custom destiny values' do
        let(:params) do
          {
            final_virus_destiny: 'D_REJECT',
            final_banned_destiny: 'D_PASS',
            final_spam_destiny: 'D_BOUNCE',
            final_bad_header_destiny: 'D_DISCARD'
          }
        end

        it 'accepts custom destiny settings' do
          is_expected.to compile
        end
      end

      context 'with custom max_servers' do
        let(:params) do
          {
            max_servers: 10
          }
        end

        it 'accepts custom server count' do
          is_expected.to compile
        end
      end

      context 'with whitelist entries' do
        let(:params) do
          {
            whitelist: true,
            whitelist_entries: [
              'example.com',
              'trusted.example.org'
            ]
          }
        end

        it 'accepts whitelist configuration' do
          is_expected.to compile
        end
      end

      context 'with scanning disabled' do
        let(:params) do
          {
            scanning_disabled: true
          }
        end

        it 'accepts scanning disabled configuration' do
          is_expected.to compile
        end
      end

      context 'with invalid destiny value' do
        let(:params) do
          {
            final_virus_destiny: 'INVALID'
          }
        end

        it 'fails compilation' do
          expect { catalogue }.to raise_error(Puppet::Error, /expects a match for Enum/)
        end
      end
    end
  end
end
