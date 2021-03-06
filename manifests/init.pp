class rstudio {

  # Set up two proxies:
  #   The first forwards port 80 to 443
  #   The second forwards port 443 to rstudio
  include rstudio::proxy

  singleton_resources(
    Package['r-base'],
    Package['rstudio-server'],
  )

  file {
    "/etc/rstudio/rserver.conf":
      ensure  => file,
      content => template("rstudio/rserver.erb"),
  }

  file {
    "/etc/rstudio/rsession.conf":
      ensure  => file,
      content => template("rstudio/rsession.erb"),
  }

  service {
    "rstudio-server":
      provider   => $operatingsystem ? {
        'Ubuntu' => 'upstart',
        default  => undef,
      },
      ensure     => 'running',
      require    => Package['rstudio-server'],
      subscribe  => [
        File['/etc/rstudio/rserver.conf'],
        File['/etc/rstudio/rsession.conf'],
      ],
  }

}
