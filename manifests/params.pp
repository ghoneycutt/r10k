# Reasonable defaults for all classes
class r10k::params
{
  $package_name      = ''
  $version           = '1.1.0'
  $manage_modulepath = false
  $install_options   = ''
  $sources           = undef

  # r10k configuration
  $r10k_config_file = '/etc/r10k.yaml'
  $r10k_cache_dir   = '/var/cache/r10k'
  $r10k_basedir     = "${::settings::confdir}/environments"
  $r10k_purgedirs   = $r10k_basedir

  # Git configuration
  $git_server = $::settings::ca_server
  $repo_path  = '/var/repos'
  $remote     = "ssh://${git_server}${repo_path}/modules.git"

  # prerun_command in puppet.conf
  $prerun_command = 'r10k deploy environment -p'

  # Gentoo specific values
  $gentoo_keywords = ''

  # Include the mcollective agent
  $mcollective = false

  if $::is_pe =~ /true/ {
    # Puppet Enterprise specific settings
    $puppetconf_path = '/etc/puppetlabs/puppet'

    $pe_module_path  = '/opt/puppet/share/puppet/modules'
    # Mcollective configuration dynamic
    $mc_service_name = 'pe-mcollective'
    $plugins_dir     = '/opt/puppet/libexec/mcollective/mcollective'
    $modulepath      = "${r10k_basedir}/\$environment/modules:${pe_module_path}"
    $provider        = 'pe_gem'
  } else {
    # Getting ready for FOSS support in this module
    $puppetconf_path = '/etc/puppet'

    # Mcollective configuration dynamic
    $mc_service_name = 'mcollective'
    $modulepath = "${r10k_basedir}/\$environment/modules"

    case $::osfamily {
      'debian': {
        $plugins_dir = '/usr/share/mcollective/plugins/mcollective'
        $provider    = 'gem'
      }
      'gentoo': {
        $plugins_dir = '/usr/libexec/mcollective/mcollective'
        $provider    = 'portage'
      }
      default: {
        $plugins_dir = '/usr/libexec/mcollective/mcollective'
        $provider    = 'gem'
      }
    }
  }

  # Mcollective configuration static
  $mc_agent_name       = "${module_name}.rb"
  $mc_agent_ddl_name   = "${module_name}.ddl"
  $mc_app_name         = "${module_name}.rb"
  $mc_agent_path       = "${plugins_dir}/agent"
  $mc_application_path = "${plugins_dir}/application"
}
