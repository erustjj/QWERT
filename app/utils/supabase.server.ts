import { createClient } from '@supabase/supabase-js';

// Use the environment variable names defined in the .env file
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  // This error will be thrown if the environment variables are not loaded correctly
  // Ensure your Remix setup loads environment variables (e.g., using a package like dotenv or built-in Remix features if available)
  throw new Error('Missing SUPABASE_URL or SUPABASE_ANON_KEY environment variables.');
}

// Create a single Supabase client for interacting with your database
export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Note: For server-side rendering in Remix, you might need to handle
// the client creation differently depending on your authentication strategy.
// This is a basic example for server-side data fetching.
// For client-side interactions or more complex auth, refer to Supabase/Remix docs.
