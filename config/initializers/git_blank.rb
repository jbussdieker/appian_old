# Create the blank git project template
f = File.join(Rails.configuration.root, "templates", "blank")
FileUtils.mkdir_p(f)
`cd #{f} && git init --bare`

# Symbolic links to global commit scripts
s = File.join(Rails.configuration.root, "script", "git-hooks")
d = File.join(Rails.configuration.root, "templates", "blank", "hooks")
`ln -s #{s}/update #{d}/update`
`ln -s #{s}/post-update #{d}/post-update`

