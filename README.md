Given a project, and a list of developers for that project, produce
rudimentary metrics. Note that this is ASF-project centric.

Projects are defined in yaml files, in $DATA/projects, and look like:

activemq.yml
------------

name: ActiveMQ
service: Amazon MQ
domain: activemq
lists:
    - dev
    - user
devs:
   - nshuplet
   - pdeasy
repo: activemq

Devs are defined in yaml files in $DATA/devs and look like:

pdeasy.yml
----------

name: Patrick Deasy
apacheid: pdeasy
email: pa-deasy@hotmail.com
githubid: pa-deasy

You'll need to define $DATA in `mentorstats` to point to wherever you
stash the data files.

