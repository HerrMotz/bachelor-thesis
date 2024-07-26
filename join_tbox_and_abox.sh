#!/bin/bash

cat OntologieStartTBox.owl > OntologieJoint.owl
echo "\n\n#ABox" >> OntologieJoint.owl
cat OntologieStartIndividuals >> OntologieJoint.owl
