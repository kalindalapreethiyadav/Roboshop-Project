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

cart:
	sh components/cart.sh

redis:
	sh components/redis.sh

mysql:
	sh components/mysql.sh

shipping:
	sh components/shipping.sh

RabbitMQ:
	sh components/RabbitMQ.sh

payment:
	sh components/payment.sh

Dispatch:
	sh components/dispatch.sh



