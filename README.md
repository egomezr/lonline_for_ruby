[![Gem Version](https://badge.fury.io/rb/lonline.svg)](https://badge.fury.io/rb/lonline)

# For Ruby 
Lonline allows you to log your program's execution into the cloud to avoid server access and disk space usage.

Lonline provides 6 levels of logging and 2 methods to execute reports.  Lonline is a gem to log your program through a storing service called Dynamicloud.  With Dynamicloud we can store data dynamically and very easy, Lonline allows you to set more features and this way log more than only text, level and program trace.

# Lonline manager

This manager allows you to check your logs from anywhere, likewise you will be able to configure alerts, execute searchs, import and create containers, <a href="https://lonline.io/wizard" target="_blank">Configuration Wizard</a>, etc.

**Access here:** <a href="https://lonline.io/" target="_blank">Lonline manager</a>

**This documentation has the following content:**

1. [Dependencies](#dependencies)
2. [Settings](#settings)
  1. [Installation](#installation)
  2. [Dynamicloud account](#dynamicloud-account)
3. [How to use](#how-to-use)
  1. [Log using the six levels](#log-using-the-six-levels)
  2. [Additional data](#additional-data)
  3. [Execute reports](#execute-reports)

# Dependencies
**Lonline has two main dependendencies:** Json gem and Dynamicloud gem, so when you're installing lonline gem those dependencies will be installed in your system.

# Installation
Install lonline like any other Ruby gem:

**To install gem from your command line:**

`gem install lonline`

**To add the gem to your Gemfile**

`gem 'lonline'`

and run at the command line:

`bundle install`

# Settings
Lonline needs a basic settings to be configured, Lonline gem comes with a generator to create two main files: lonline.yml and an initializer called lonline.rb (The content of this initializer could be within another initializer in your Rails app).

**For Rails applications execute the generator from your command line as follow:**

`rails g lonline`

**That command will create two files:** `config/lonline.yml` and `initializer/lonline.rb`

**config/lonline.yml**

```yml
test: &default
  # Credentials for REST APIs
  # Go to https://www.dynamicloud.org/manage and get the API keys available in your profile
  # If you don't have an account in Dynamicloud, visit https://www.dynamicloud.org/signupform
  # You can easily use a social network to sign up
  csk: Enter your Client_Secret_Key
  aci: Enter your API_Client_Id
  # This is the model identifier for test and development environment
  # The model contains the structure to store logs into the cloud
  # For more information about models in Dynamicloud visit https://www.dynamicloud.org/documents/apidoc#main_concepts
  model_identifier: 0
  # async = true is the best choice to avoid impact in your app's execution.
  # If you want to wait for every request, set async: false
  async: false
  # Shows every warning like rejected request from Dynamicloud and other warnings in lonline
  warning: true
  # Send the backtrace (the ordered method calls) of the log.  If you want to avoid this sets to false
  backtrace: true
  # This tag indicates the level of lonline
  # The following table is an explanation of levels in Lonline (Descriptions from the great Log4j library):
  # ------------------------------------------------------------------------------------------------------------
  # | Level      | Activated levels           | Description                                                    |
  # ------------------------------------------------------------------------------------------------------------
  # | fatal      | Fatal                      | Designates very severe error events that will presumably lead  |
  # |            |                            | the application to abort.                                      |
  # ------------------------------------------------------------------------------------------------------------
  # | error      | Fatal, Error               | Designates error events that might still allow the application |
  # |            |                            | to continue running.                                           |
  # ------------------------------------------------------------------------------------------------------------
  # | warn       | Fatal, Error, Warn         | Designates potentially harmful situations.                     |
  # ------------------------------------------------------------------------------------------------------------
  # | info       | Fatal, Error, Warn, Info   | Designates informational messages that highlight the progress  |
  # |            |                            | of the application at coarse-grained level.                    |
  # ------------------------------------------------------------------------------------------------------------
  # | debug      | Fatal, Error, Info, Warn   | Designates fine-grained informational events that are most     |
  # |            | Debug                      | useful to debug an application.                                |
  # ------------------------------------------------------------------------------------------------------------
  # | trace      | All levels                 | Traces the code execution between methods, lines, etc.         |
  # ------------------------------------------------------------------------------------------------------------
  # | off        | None                       | The highest possible rank and is intended to turn off logging. |
  # ------------------------------------------------------------------------------------------------------------
  level: trace
  # report_limit indicates how many records lonline will execute to fetch data from Dynamicloud.
  # If you need to increase this value, please think about the available requests per month in your account.
  # Dynamicloud uses a limit of records per request, at this time the max records per request is 20.  So,
  # report_limit=100 are 5 request.
  report_limit: 100
development:
  <<: *default
production:
  <<: *default
  # Credentials for REST APIs in production environment
  # Go to https://www.dynamicloud.org/manage and get the API keys available in your profile
  # If you don't have an account in Dynamicloud, visit https://www.dynamicloud.org/signupform
  # You can easily use a social network to sign up
  csk: Enter your Client_Secret_Key
  aci: Enter your API_Client_Id
  # This is the model id for production environment
  model_identifier: 0
  # async = true is the best choice to avoid impact in your app's execution.
  # If you want to wait for every request, set async: false
  async: true
  # Shows every warning like rejected request from Dynamicloud
  warning: false
  # Send the backtrace of the log.  If you want to avoid this sets to false
  backtrace: true
  # This tag indicates the level of lonline
  # The following table is an explanation of levels in Lonline (Descriptions from the great Log4j library):
  # ------------------------------------------------------------------------------------------------------------
  # | Level      | Activated levels           | Description                                                    |
  # ------------------------------------------------------------------------------------------------------------
  # | fatal      | Fatal                      | Designates very severe error events that will presumably lead  |
  # |            |                            | the application to abort.                                      |
  # ------------------------------------------------------------------------------------------------------------
  # | error      | Fatal, Error               | Designates error events that might still allow the application |
  # |            |                            | to continue running.                                           |
  # ------------------------------------------------------------------------------------------------------------
  # | warn       | Fatal, Error, Warn         | Designates potentially harmful situations.                     |
  # ------------------------------------------------------------------------------------------------------------
  # | info       | Fatal, Error, Warn, Info   | Designates informational messages that highlight the progress  |
  # |            |                            | of the application at coarse-grained level.                    |
  # ------------------------------------------------------------------------------------------------------------
  # | debug      | Fatal, Error, Info, Warn   | Designates fine-grained informational events that are most     |
  # |            | Debug                      | useful to debug an application.                                |
  # ------------------------------------------------------------------------------------------------------------
  # | trace      | All levels                 | Traces the code execution between methods, lines, etc.         |
  # ------------------------------------------------------------------------------------------------------------
  # | off        | None                       | The highest possible rank and is intended to turn off logging. |
  # ------------------------------------------------------------------------------------------------------------
  level: error
  # report_limit indicates how many records lonline will execute to fetch data from Dynamicloud.
  # If you need to increase this value, please think about the available requests per month in your account.
  # Dynamicloud uses a limit of records per request, at this time the max records per request is 20.  So,
  # report_limit=100 are 5 request (if your report execution has at least 100 logs).
  report_limit: 100
```

**initializer/lonline.rb**
```ruby
Lonline::SETUP.load('config/lonline.yml', Rails.env)
# The line below sets the logger you're using in your program, every call of lonline will execute the same method in your logger
# For example:
# Lonline.log.fatal('The app has crashed and its state is unavailable') # This call will execute the following method in your logger
# logger.fatal('The app has crashed and its state is unavailable') # If this method is unavailable, lonline
# will catch the error without any feedback to you.
# If you don't need this behavior, remove this line.
Lonline::SETUP.logger = Rails.logger
```

**For Ruby applications (No Rails) add these two lines of code to setup lonline:**

```ruby
Lonline::SETUP.load('test/lonline.yml', 'test')
Lonline::SETUP.logger = logger #If your Ruby app doesn't have logger remove this line.
```

### Dynamicloud account

Lonline needs API credentials from a Dynamicloud account, these credentials allow Lonline to access your account's structure (Model).  The mandatory model in your account should be composed for a model with at least three fields.  For further information about models and fields in Dynamicloud visit its documentation at [Main concepts](https://www.dynamicloud.org/documents/apidoc#main_concepts "Dynamicloud documentation")

> If you don't have a Dynamicloud account, <a href="https://lonline.io/" target="_blank">Lonline Manager</a> provides an option on <a href="https://lonline.io/auth/signup" target="_blank">Sign up</a> page to create a Dynamicloud account for you.

> Another tool in Lonline Manager is a <a href="https://lonline.io/wizard" target="_blank">Configuration Wizard</a> to setup Lonline in your system.

**We are going to explain step by step how to setup your account in Dynamicloud, trust us it's very easy:**

1. Sign up in Dynamicloud (You can use either Google, Linkedin or Github account to speed up the registration)
2. Click on **Add Field** link at your **Real time Dashboard**.  Here you need to add three fields:
  
a. **Fields:**
  
| Field identifier | Field label | Field comments | Field type | Is a required field in form? |
| --- | --- | --- | --- | --- |
| `lonlinetext` | Log text | Contains the trace of this log | Textarea | **Yes** |
| `lonlinelevel` | Log level | Contains the log level | Combobox | **Yes** |
| `lonlinetrace` | Complete Trace | Contains the complete trace of the log | Textarea | **No** |  
  
b. **`lonlinelevel` is a combobox.  You need to add the following options:**
  
| Value | Text |
| --- | --- |
| `Fatal` | Fatal |
| `error` | Error |
| `warn` | Warn |
| `Info` | Info |
| `debug` | Debug |
| `trace` | Trace |

**To add these options follow the steps below:**

1. Click on **Global Fields** link at your **Real time Dashboard**
2. In the table of fields find the row with the identifier `lonlinelevel`
3. Click on **Manage items** link.  An empty list of items will be shown, there click on **Add new** button and fill the value and text field
4. The step number three should be executed six times according to the available levels (Fatal, Error, Warn, Info, Debug and Trace).

c. **Add model**
  
A model is the container of these fields, to add a model follow the next steps:

1. Click on **Add model** link at your **Real time Dashboard**
2. Fill the mandatory field name and set a description (Optional)
3. Press button Create
4. In the list of Models the Model box has a header with the model Id, copy that Id and put it in your `lonline.yml` file 
   
```yml
# This is the model identifier for test and development environment
# The model contains the structure to store logs into the cloud
# For more information about models in Dynamicloud visit https://www.dynamicloud.org/documents/mfdoc
model_identifier: 0
```
  
#### The last step is to copy the API credentials (CSK and ACI keys) to put them in your `lonline.yml` file.

1. Click on **Your name link at left top of your account**
2. Copy the CSK and ACI keys and put them into your `lonline.yml` file.

```yml
# Credentials for REST APIs
# Go to https://www.dynamicloud.org/manage and get the API keys available in your profile
# If you don't have an account in Dynamicloud, visit https://www.dynamicloud.org/signupform
# You can easily use a social network to sign up
csk: Enter your Client_Secret_Key
aci: Enter your API_Client_Id
```

At this point you have the necessary to start to log your program into the cloud.

# How to use
Lonline is easy to use, one line of code logs and stores into the cloud.

### Log using the six levels

```ruby
Lonline.log.trace('Calling method Y')
Lonline.log.debug('Creating new object')
Lonline.log.info('Process has finished')
Lonline.log.warn("It could'n create this object, the process will try later.")
Lonline.log.error('Unable to load setting file')
Lonline.log.fatal('The app has crashed and its state is unavailable')
```

### Additional data
Lonline gem allows you to log further data.  If you want to log more information (For example: The module in your application who has executed the log.) just pass a hash with the attributes and values.  Remember that these additional attributes must match with the fields in your model, so you need to add these fields before to log.

**To log additional information, follow the code below:**
```ruby
Lonline.log.trace('Calling method Y', 
        {
          :module => 'Financial module',
          :user => 'eleazar',
          :user_id => 454545
        })
```

In the above example, you need to add three additional fields to your model, two of them as TextField and one as Number.

### Execute reports
Lonline allows you to execute reports about the executed logs and count how many logs have been created so far.

```ruby
# These report fetches the fatal logs from today.
Lonline::Report.fetch(:fatal, from, Time.now.utc) do |log|
  puts log[:text] # Log you have sent
  puts log[:when] # When this log was created
  puts log[:trace] # Trace you have sent
end

from = Time.now
from = Time.new(from.year, from.month, from.day, 0, 0, 0)

# Count of fatal logs from today at the beginning of the day.
count = Lonline::Report.count(:fatal, from, Time.now.utc)

puts "Count = #{count}"
```

