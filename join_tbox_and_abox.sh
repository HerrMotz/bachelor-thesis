#!/bin/bash

NEW="OntologieJoint.owl"

cat OntologieStartTBox.owl > "$NEW"
echo "" >> "$NEW"
echo "#ABox" >> "$NEW"
cat OntologieStartIndividuals.owl >> "$NEW"
