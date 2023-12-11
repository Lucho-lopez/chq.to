module LinkValidations
    extend ActiveSupport::Concern

    included do
        validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "es inválido, un ejemplo válido es https://catedras.linti.unlp.edu.ar/" }
        validates :link_password, presence: true, if: -> { link_type == 'private' }
        validates :expires_at, presence: true, if: -> { link_type == 'temporal' }
        validate :url_not_same_as_current_domain
    end

    HUMANIZED_ATTRIBUTES = {
        link_name: "Nombre del link",
        link_type: "Tipo de link",
        expires_at: "Expira",
        link_password: "Contraseña",
        unique_token: "Token único"
    }.freeze

    def self.human_attribute_name(attr, options = {})
        HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    def url_not_same_as_current_domain
        return unless url.present?

        current_domain = 'chq.to'

        if URI.parse(url).host == current_domain
        errors.add(:url, "no puede ser igual al dominio actual")
        end
    end
end