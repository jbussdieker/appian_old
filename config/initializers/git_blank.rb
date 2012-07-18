# Create the blank git project template
f = File.join(Rails.configuration.root, "templates", "blank")
FileUtils.mkdir_p(f)
`cd #{f} && git init --bare`

