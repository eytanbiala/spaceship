module Spaceship
  module Tunes
    # Represents an editable version of an iTunes Connect Application
    # This can either be the live or the edit version retrieved via the app
    class AppVersion < TunesBase
      attr_accessor :application

      attr_accessor :version_id

      attr_accessor :copyright

      # @return (Bool) Is that the version that's currently available in the App Store?
      attr_accessor :is_live

      attr_accessor :primary_category

      # Categories (e.g. MZGenre.Business)
      attr_accessor :primary_first_sub_category

      attr_accessor :primary_second_sub_category

      attr_accessor :secondary_category

      attr_accessor :secondary_first_sub_category

      attr_accessor :secondary_second_sub_category

      # @return (String) App Status (e.g. 'readyForSale')
      attr_accessor :status

      # @return (Bool)
      attr_accessor :can_reject_version

      # @return (Bool)
      attr_accessor :can_prepare_for_upload

      # @return (Bool)
      attr_accessor :can_send_version_live

      # @return (Bool) Should the app automatically be released once it's approved?
      attr_accessor :release_on_approval

      # @return (Bool)
      attr_accessor :can_beta_test

      # @return (Bool) Does the binary contain a watch binary?
      attr_accessor :supports_apple_watch

      # @return (String) URL to the full resolution 1024x1024 app icon
      attr_accessor :app_icon_url

      # @return (String) Name of the original file
      attr_accessor :app_icon_original_name

      # @return (String) URL to the full resolution 1024x1024 app icon
      attr_accessor :watch_app_icon_url

      # @return (String) Name of the original file
      attr_accessor :watch_app_icon_original_name

      # TODO
      attr_accessor :review_first_name

      # @return TODO
      attr_accessor :company_information

      ####
      # Localized values:
      ####

      # @return (Array) Raw access the all available languages. You shouldn't use it probbaly
      attr_accessor :languages

      # @return (Hash) A hash representing the app name in all languages
      attr_reader :name

      # @return (Hash) A hash representing the keywords in all languages
      attr_reader :keywords

      # @return (Hash) A hash representing the description in all languages
      attr_reader :description

      # @return (Hash) A hash representing the keywords in all languages
      attr_reader :privacy_url

      # @return (Hash) A hash representing the keywords in all languages
      attr_reader :support_url

      # @return (Hash) A hash representing the keywords in all languages
      attr_reader :marketing_url


      attr_mapping({
        'versionId' => :version_id,
        'copyright' => :copyright,
        'primaryCategory' => :primary_category,
        'primaryFirstSubCategory' => :primary_first_sub_category,
        'primarySecondSubCategory' => :primary_second_sub_category,
        'secondaryCategory' => :secondary_category,
        'secondaryFirstSubCategory' => :secondary_first_sub_category,
        'secondarySecondSubCategory' => :secondary_second_sub_category,
        'status' => :status,
        'canRejectVersion' => :can_reject_version,
        'canPrepareForUpload' => :can_prepare_for_upload,
        'canSendVersionLive' => :can_send_version_live,
        'details' => :languages,
        'largeAppIcon.value.url' => :app_icon_url,
        'largeAppIcon.value.originalFileName' => :app_icon_original_name,
        'watchAppIcon.value.url' => :watch_app_icon_url,
        'watchAppIcon.value.originalFileName' => :watch_app_icon_original_name,
        'canBetaTest' => :can_beta_test,
        'releaseOnApproval' => :release_on_approval,
        'supportsAppleWatch' => :supports_apple_watch
      })

      class << self
        # Create a new object based on a hash.
        # This is used to create a new object based on the server response.
        def factory(attrs)
          orig = attrs.dup
          obj = self.new(attrs)
          obj.raw_data = orig
          obj.unfold_languages

          obj.fix_apples_bugs

          obj
        end

        # @return (Array) Returns all apps available for this account
        # TODO: describe parameters
        def find(application, app_id, is_live = false)
          attrs = client.app_version(app_id, is_live)
          attrs.merge!(application: application)
          attrs.merge!(is_live: is_live)

          return self.factory(attrs)
        end
      end

      # Prefill name, keywords, etc...
      def unfold_languages
        {
          name: :name, 
          keywords: :keywords, 
          description: :description, 
          privacyURL: :privacy_url, 
          supportURL: :support_url, 
          marketingURL: :marketing_url
        }.each do |json, attribute|
          instance_variable_set("@#{attribute}".to_sym, LanguageItem.new(json, languages))
        end
      end

      # This method takes care of properly parsing values that
      # are not returned in the right format, e.g. boolean as string
      def fix_apples_bugs
        self.release_on_approval = (release_on_approval == 'true')
        self.supports_apple_watch = (supports_apple_watch != nil)
      end

      def is_live?
        is_live
      end

      # TODO: comment
      def save!
        client.update_app_version(application.apple_id, is_live?, raw_data)
      end
    end
  end
end 