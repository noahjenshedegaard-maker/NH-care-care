// NH Car Care settings
// Paste your two values from Supabase > Project Settings > API (or "API Keys").
// The anon / publishable key is safe to have in a public website — the
// database rules only let visitors CREATE bookings, never read them.
window.NH_CONFIG = {
  SUPABASE_URL: "https://mfslcgakveihjhdgfdfk.supabase.co",
  SUPABASE_ANON_KEY: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1mc2xjZ2FrdmVpaGpoZGdmZGZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMzODk2NjUsImV4cCI6MjEwODk2NTY2NX0.aXgdA7kVyXroN52VZ3h_GI_DpoWge0H_lZMBCUXvfGA",
  PHONE: "+971 58 281 8849",
  // The email of your admin user in Supabase (Authentication > Users).
  // The admin page only asks for the password; it logs in with this email.
  ADMIN_EMAIL: "admin@nhcarcare.com"
};
