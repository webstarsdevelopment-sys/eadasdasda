-- Drop the old settings table and recreate with proper structure
DROP TABLE IF EXISTS settings;

-- Create settings table with proper columns
CREATE TABLE IF NOT EXISTS settings (
  id SERIAL PRIMARY KEY,
  active_sheet_id TEXT REFERENCES sheets(id) ON DELETE SET NULL,
  filter_duplicates BOOLEAN DEFAULT true,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all operations for anonymous users
CREATE POLICY "Allow all operations on settings" ON settings FOR ALL USING (true) WITH CHECK (true);

-- Also fix sheets table to use auto-generated UUID instead of text
-- First drop dependent tables
DROP TABLE IF EXISTS call_statuses;
DROP TABLE IF EXISTS notes;
DROP TABLE IF EXISTS sheets;

-- Recreate sheets with proper UUID
CREATE TABLE IF NOT EXISTS sheets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  label TEXT NOT NULL,
  url TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Recreate call_statuses
CREATE TABLE IF NOT EXISTS call_statuses (
  id SERIAL PRIMARY KEY,
  lead_id TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'not_called',
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(lead_id)
);

-- Recreate notes
CREATE TABLE IF NOT EXISTS notes (
  id SERIAL PRIMARY KEY,
  lead_id TEXT NOT NULL,
  note TEXT DEFAULT '',
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(lead_id)
);

-- Enable RLS on all tables
ALTER TABLE sheets ENABLE ROW LEVEL SECURITY;
ALTER TABLE call_statuses ENABLE ROW LEVEL SECURITY;
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow all on sheets" ON sheets FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on call_statuses" ON call_statuses FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on notes" ON notes FOR ALL USING (true) WITH CHECK (true);
