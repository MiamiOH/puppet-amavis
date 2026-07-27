require 'spec_helper'

describe 'amavis::config', type: :class do
  let(:facts) { { operatingsystem: 'Debian', operatingsystemrelease: '7.1' } }

  it { is_expected.to contain_package('amavisd-new') }
  it { is_expected.to contain_service('amavis') }
  it { is_expected.to contain_exec('amavis') }

  context 'with final_virus_destiny => D_REJECT; # (defaults to D_BOUNCE)' do
    let(:params) { { final_virus_destiny: 'D_REJECT; # (defaults to D_BOUNCE)' } }

    it { is_expected.to contain_file('/etc/amavis/conf.d/50-user').with_content(%r{\$final_virus_destiny=D_REJECT; # \(defaults to D_BOUNCE\)}) }
  end
  context 'with final_virus_destiny => undef' do
    let(:params) { {} }

    it { is_expected.to contain_file('/etc/amavis/conf.d/50-user') }
    it { is_expected.not_to contain_file('/etc/amavis/conf.d/50-user').with_content(%r{final_banned_destiny}) }
  end
  context 'with bypass_virus_checks_maps => foo' do
    let(:params) { { bypass_virus_checks_maps: 'foo' } }

    it { is_expected.to contain_file('/etc/amavis/conf.d/15-content_filter_mode').with_content(%r{@bypass_virus_checks_maps=foo}) }
  end
  context 'with bypass_virus_checks_maps => undef' do
    let(:params) { {} }

    it { is_expected.to contain_file('/etc/amavis/conf.d/15-content_filter_mode').with_content(%r{@bypass_virus_checks_maps}) }
  end
end
