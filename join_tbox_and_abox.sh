#!/bin/bash

NEW="OntologieJoint.owl"

cat OntologieTBox.owl > "$NEW"
echo "" >> "$NEW"
echo "#ABox" >> "$NEW"
cat OntologieABox.owl >> "$NEW"
