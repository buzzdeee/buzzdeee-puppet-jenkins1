require 'spec_helper'

describe 'jenkins', :type => :module  do
  let(:facts) do
    {
      :osfamily                  => 'RedHat',
      :operatingsystem           => 'RedHat',
      :operatingsystemrelease    => '6.7',
      :operatingsystemmajrelease => '6',
    }
  end

  context 'service' do
    context 'default' do
      it { should contain_service('jenkins').with(:ensure => 'running', :enable => true) }
    end
    context 'EL 7' do
      let(:facts) do
        super().merge( {:operatingsystemrelease => '7.1.1503', :operatingsystemmajrelease => '7'})
      end
      it { should contain_service('jenkins').with(:ensure => 'running', :enable => true, :provider => 'redhat') }
    end
    context 'EL 6' do
      let(:facts) do
        super().merge( {:operatingsystemrelease => '6.6', :operatingsystemmajrelease => '6'})
      end
      it { should contain_service('jenkins').with(:ensure => 'running', :enable => true) }
    end
    context 'managing service' do
      let(:params) { { :service_ensure => 'stopped', :service_enable => false } }
      it { should contain_service('jenkins').with(:ensure => 'stopped', :enable => false ) }
    end
  end

  context 'non default service_flags on OpenBSD' do
    let(:facts) { { :osfamily => 'OpenBSD', :operatingsystem => 'OpenBSD' } }
    let(:params) { { :service_flags => 'myflags' } }
    it { should contain_service('jenkins').with(:flags => 'myflags') }
  end
  context 'service_flags set on not OpenBSD OS' do
    let(:facts) { { :osfamily => 'RedHat', :operatingsystem => 'RedHat' } }
    let(:params) { { :service_flags => 'myflags' } }
    it { should_not contain_service('jenkins').with(:flags => 'myflags') }
  end
end
