ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation
ON documents
--FOR SELECT / FOR ALL --> Policies can target specific commands
USING (
    tenant_id =
        current_setting('app.tenant_id')::UUID
)
--FOR INSERT / FOR ALL --> Policies can target specific commands
WITH CHECK (
    tenant_id =
        current_setting('app.tenant_id')::UUID
);