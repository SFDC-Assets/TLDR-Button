# Create the demo org
sfdx shane:org:create -f config/project-scratch-def.json -d 30 -s --wait 60 --userprefix chatgpt -o integration.demo 

# Push the metadata into the new scratch org.
sfdx force:source:push

# Push sample data
sfdx automig:load --inputdir ./data --deletebeforeload

# Set the default password.
sfdx shane:user:password:set -g User -l User -p salesforce1

# Open the org.
sfdx force:org:open -p /lightning/o/Case/list



