class ImapClient
  VERSION="1.0.0"
end

require 'imap_client/rendezvous_hash'
require 'imap_client/process_uid'
require 'imap_client/user_thread'
require 'imap_client/daemon'
require 'call_new_email_webhook_worker'
require 'schedule_tracer_emails_worker'