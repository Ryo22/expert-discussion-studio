-- ============================================================
-- Expert Discussion Studio - Supabase セットアップSQL
-- Supabase Dashboard > SQL Editor でこのSQLを実行してください
-- ============================================================

-- 1. テーブル作成
CREATE TABLE IF NOT EXISTS eds_cloud_data (
  id          BIGSERIAL PRIMARY KEY,
  user_id     UUID        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  data_key    TEXT        NOT NULL,
  content     JSONB,                          -- JSONB型必須（TEXTだとオブジェクトが壊れる）
  updated_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (user_id, data_key)                  -- upsert の onConflict に必要
);

-- 2. Row Level Security を有効化
ALTER TABLE eds_cloud_data ENABLE ROW LEVEL SECURITY;

-- 3. 認証済みユーザーが自分のデータのみ操作できるポリシー
CREATE POLICY "users_own_data" ON eds_cloud_data
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- ※ 既存テーブルがある場合は一度削除してから再実行してください:
-- DROP TABLE IF EXISTS eds_cloud_data;
-- ============================================================

-- 確認クエリ（実行後に動作確認したい場合）
-- SELECT * FROM eds_cloud_data LIMIT 10;
