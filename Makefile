# A Makefile is a collection of rules.  Each rule is a recipe to do a specific
# thing, sort of like a grunt task or an npm package.json script.
#
# A rule looks like this:
#
# <target>: <prerequisites...>
# 	<commands>
#
catalogue:
	sh components/catalogue.sh

frontend:
	sh components/frontend.sh

mongodb:
	sh components/mongodb.sh

user:
	sh components/user.sh

