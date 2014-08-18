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
