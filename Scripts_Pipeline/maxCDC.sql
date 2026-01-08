@concat(
  'SELECT MAX(last_updated) as cdc_timestamp FROM ',
  pipeline().parameters.schema,
  '.',
  pipeline().parameters.table
)
