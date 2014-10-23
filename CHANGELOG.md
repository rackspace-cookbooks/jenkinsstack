# 1.4.0

- Move away from logstash_commons, just set attributes in case elkstack is present.

# 1.3.0

Allow server name to be set (#34).

# 1.2.0

Add elkstack logging for Jenkins logs if ELK available.

# 1.1.0

Serverspec update, slave fixes/simplifications

# 1.0.1

Refactor auth to prevent a problem during convergence. Now, the chef user and
credentials are created but not passed to jenkins::* recipes on the first chef
run, and at the very end, Jenkins is restarted. The credentials are only passed
on subsequent runs which require them after the restart.

# 1.0.0

Java behavior has been extracted into its own recipe. Call the java recipe here
to use a wrapper from jenkins::java. Otherwise, you must ensure java is installed
before using the master or slave recipes in this cookbook.


# 0.1.0

Initial release of jenkinsstack
