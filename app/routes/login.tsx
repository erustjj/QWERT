import type { ActionFunctionArgs, MetaFunction } from "@remix-run/node";
import { Form, useActionData, redirect } from "@remix-run/react"; // Import redirect and useActionData
import { supabase } from "~/utils/supabase.server"; // Import the Supabase client

export const meta: MetaFunction = () => {
  return [
    { title: "Login - Depo Yönetim Sistemi" },
    { name: "description", content: "Login to the Warehouse Management System" },
  ];
};

export async function action({ request }: ActionFunctionArgs) {
  const formData = await request.formData();
  const email = formData.get("email") as string;
  const password = formData.get("password") as string;

  // Implement Supabase login logic here
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) {
    console.error("Login error:", error);
    // Return error to the component
    return { error: error.message };
  }

  // Handle successful login (e.g., set session cookie, redirect)
  console.log("Login successful:", data);
  // Redirect to dashboard on success
  return redirect("/dashboard");

}

export default function LoginPage() {
  // Display login errors if any
  const actionData = useActionData<typeof action>();

  return (
    <div className="flex h-screen items-center justify-center bg-gray-100 dark:bg-gray-900">
      <div className="w-full max-w-md rounded-lg bg-white p-8 shadow-md dark:bg-gray-800">
        <h2 className="mb-6 text-center text-2xl font-bold text-gray-800 dark:text-gray-100">
          Giriş Yap
        </h2>
        <Form method="post" className="space-y-6">
          <div>
            <label
              htmlFor="email"
              className="block text-sm font-medium text-gray-700 dark:text-gray-300"
            >
              E-posta
            </label>
            <input
              id="email"
              name="email"
              type="email"
              required
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 dark:border-gray-600 dark:bg-gray-700 dark:text-white dark:focus:border-blue-600 dark:focus:ring-blue-600 sm:text-sm"
            />
          </div>
          <div>
            <label
              htmlFor="password"
              className="block text-sm font-medium text-gray-700 dark:text-gray-300"
            >
              Şifre
            </label>
            <input
              id="password"
              name="password"
              type="password"
              required
              className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 dark:border-gray-600 dark:bg-gray-700 dark:text-white dark:focus:border-blue-600 dark:focus:ring-blue-600 sm:text-sm"
            />
          </div>
          {/* Display error message here */}
          {actionData?.error && (
            <p className="text-red-500 text-sm">{actionData.error}</p>
          )}
          <div>
            <button
              type="submit"
              className="flex w-full justify-center rounded-md border border-transparent bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 dark:bg-blue-700 dark:hover:bg-blue-800 dark:focus:ring-blue-800"
            >
              Giriş Yap
            </button>
          </div>
        </Form>
      </div>
    </div>
  );
}
