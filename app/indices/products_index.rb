ThinkingSphinx::Index.define :product, with: :active_record do
  #fields
  indexes title, sortable: true
  indexes description
  indexes brand_id, sortable: true
  indexes brand.title, as: :brand, sortable: true
end
