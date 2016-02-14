# This generator creates the files to setup lonline
# Will create an initializer to load lonline settings
# Will create a setting file as a template to put information about
# Dynamicloud credentials and more settings.
class LonlineGenerator < Rails::Generators::Base
  def create_initializer_file
    create_file 'config/initializers/lonline.rb',
                "Lonline::SETUP.load('config/lonline.yml', Rails.env)
# The line below sets the logger you're using in your program, every call of lonline will execute the same method in your logger
# For example:
# Lonline.log.fatal('The app has crashed and its state is unavailable') # This call will execute the following method in your logger
# logger.fatal('The app has crashed and its state is unavailable') # If this method is unavailable, lonline
# will catch the error without any feedback to you.
# If you don't need this behaviour, remove this line.
Lonline::SETUP.logger = Rails.logger"

    create_file 'config/lonline.yml',
                "test: &default
  # Credentials for REST APIs
  # Go to https://www.dynamicloud.org/manage and get the API keys available in your profile
  # If you don't have an account in Dynamicloud, visit https://www.dynamicloud.org/signupform
  # You can easily use a social network to sign up
  csk: Enter your Client_Secret_Key
  aci: Enter your API_Client_Id
  # This is the model identifier for test and development environment
  # The model contains the structure to store logs into the cloud
  # For more information about models in Dynamicloud visit https://www.dynamicloud.org/documents/mfdoc
  model_identifier: 0
  # async = true is the best choice to avoid impact in your app's execution.
  # If you want to wait for every request, set async: false
  async: false
  # Shows every warning like rejected request from Dynamicloud and other warnings in lonline
  warning: true
  # Send the backtrace (the ordered method calls) of the log.  If you want to avoid this set to false
  backtrace: true
  # This tag indicates the level of lonline
  # The following table is an explanation of levels in Lonline (Descriptions from Log4j documentation):
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
  # Send the backtrace of the log.  If you want to avoid this set to false
  backtrace: true
  # This tag indicates the level of lonline
  # The following table is an explanation of levels in Lonline (Descriptions from Log4j documentation):
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
  report_limit: 100"
  end
end