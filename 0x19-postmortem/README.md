 0x19-postmortem
- An outage occurred on an isolated "Ubuntu 14.04" container running an Apache web server shortly after the publication of "ALX School @Ys System Engineering & Dev Ops project 0x19." When GET calls were made to the server, 500 Internal Server Errors were returned instead of the HTML file specifying a straightforward Holberton WordPress site. ## Debugging Process - 1: Used ps aux to inspect currently active processes. Root and www-data were two apache2 processes that were successfully executed.
- 2: Scan the /etc/apache2/ directory's sites-available folder. discovered that /var/www/html/ was the location of the content being served by the web server.
3: In one terminal, run strace on the PID of the root Apache process. In another, she curled the server. Expected great things... only to be
disappointed. Trace gave no useful information.





- 4: Repeated step 3, except on the PID of the
www-data process. Kept expectations lower this time... but was
rewarded! a trace revealed an -1 ENOENT (No such file or
directory) error occurring upon an attempt to access the file
/var/www/html/wp-includes/class-wp-locale. pp.





- 5: Looked through files in the /var/www/html/
directory one by one using Vim pattern matching to try and locate the erroneous.phpp file extension. I located it in the wp-settings.php file. (Line 137, require_once, ABSPATH.
WPINC. '/class-wp-locale.php');).
- 6: The line's trailing p was removed.
- 7: The server was tested with a new curl. 200 A-ok! - 8: Created an automated Puppet manifest to correct the mistake. * Summary - A simple typo. Gotta adore them, @Yem. Specifically, when attempting to load the file class-wp-locale. phpp, the WordPress software was running into a major issue in wp-settings.php. Class-wp-locale.php was the right file name, and it was located in the wp-content directory of the application folder.
- The error was simply fixed by eliminating the trailing p in the patch. * Prevention:: This outage was caused by an application problem rather than a web server error. Please keep the following in mind going ahead to avoid any more outages of this nature.
- Before deploying, test the application. If the program had been tested, this problem would have occurred and could have been fixed sooner. - Take note that I created a Puppet manifest [0x17-web_stack_debugging_3](0-strace_is_your_friend.pp) in reaction to this issue to automate the correction of any future occurrences of the same errors. Any phpp extensions in the /var/www/html/wp-settings.php file are changed to php by the manifest.

