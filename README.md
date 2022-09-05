Please use the sfdx commands bellow to create a scratch org and deploy the code.

sfdx force:org:create -f config/project-scratch-def.json --durationdays 30 -a scratchOrg1

sfdx force:data:record:create -s CollaborationGroup -v "Name='Trade reviewers' CollaborationType='Public'"

sfdx force:source:push -u scratchOrg1
