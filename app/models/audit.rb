class Audit < Audited::Adapters::ActiveRecord::Audit

  attr_accessible :auditable_id, :auditable_type, :action, :version, :remote_address

  include Extension::DataTable

  # Scopes
  default_scope order("created_at DESC")

  def change_audited
    result =""
    clazz = self.auditable_type.constantize
    self.audited_changes.each do |a|
      result += clazz.human_attribute_name(a[0]) + ": " + a[1].to_s + "\n\n"
    end if self.audited_changes.present?
    result
  end

end
