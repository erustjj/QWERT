import type { MetaFunction } from "@remix-run/node";

export const meta: MetaFunction = () => {
  return [
    { title: "Dashboard - Depo Yönetim Sistemi" },
    { name: "description", content: "Warehouse Management System Dashboard" },
  ];
};

export default function DashboardPage() {
  return (
    <div className="flex h-screen items-center justify-center bg-gray-100 dark:bg-gray-900">
      <h1 className="text-3xl font-bold text-gray-800 dark:text-gray-100">
        Dashboard (Coming Soon!)
      </h1>
    </div>
  );
}
