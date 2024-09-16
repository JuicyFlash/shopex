TELEGRAM = { admin_chat: Rails.application.credentials[:telegram][Rails.env.to_sym][:admin_chat],
             api_path: 'https://api.telegram.org/bot',
             api_key: Rails.application.credentials[:telegram][Rails.env.to_sym][:api_key] }.freeze
