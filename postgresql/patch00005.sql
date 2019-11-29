ALTER TABLE game ADD COLUMN revision INTEGER;
ALTER TABLE genre ADD COLUMN revision INTEGER;
ALTER TABLE media ADD COLUMN revision INTEGER;
ALTER TABLE movie ADD COLUMN revision INTEGER;
ALTER TABLE series ADD COLUMN revision INTEGER;
ALTER TABLE tv_series ADD COLUMN revision INTEGER;

UPDATE system SET value = text(5) WHERE property = 'db_version';
