-- Agentic Foundry layer index. Arrays are JSON text.
CREATE TABLE IF NOT EXISTS layers (
  id       TEXT PRIMARY KEY,           -- full git commit SHA that introduced the layer
  name     TEXT NOT NULL,              -- from front matter; not unique, a later commit may redefine a name
  parents  TEXT NOT NULL DEFAULT '[]', -- layer ids that must exist before this one
  siblings TEXT NOT NULL DEFAULT '[]', -- layer ids sharing parents; one-way, siblings need not know about you
  children TEXT NOT NULL DEFAULT '[]'  -- inverse of parents; maintained when a child registers
);
CREATE INDEX IF NOT EXISTS layers_name ON layers (name);
