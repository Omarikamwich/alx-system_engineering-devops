# Executes a command
exec { 'pkkill killmenow':
	path => '/usr/bin:/usr/sbin:/bin'
}

