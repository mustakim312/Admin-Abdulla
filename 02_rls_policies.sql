-- Enable Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.employee_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.work_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.location_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.salary_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.salary_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_audit_logs ENABLE ROW LEVEL SECURITY;

-- Helper function to verify admin role securely
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = 'admin' AND status = 'approved'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 1. Profiles Policies
CREATE POLICY "Users view own profile" ON public.profiles 
  FOR SELECT USING (auth.uid() = id OR public.is_admin());

CREATE POLICY "Users update own profile activity" ON public.profiles 
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Admins update employee profiles" ON public.profiles 
  FOR UPDATE USING (public.is_admin());

-- 2. Employee Details Policies
CREATE POLICY "Users view own details" ON public.employee_details 
  FOR SELECT USING (auth.uid() = user_id OR public.is_admin());

CREATE POLICY "Users insert own details" ON public.employee_details 
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins manage employee details" ON public.employee_details 
  FOR ALL USING (public.is_admin());

-- 3. Attendance Policies
CREATE POLICY "Employees view own attendance" ON public.attendance 
  FOR SELECT USING (auth.uid() = user_id OR public.is_admin());

CREATE POLICY "Approved employees insert own attendance" ON public.attendance 
  FOR INSERT WITH CHECK (
    auth.uid() = user_id AND 
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND status = 'approved')
  );

CREATE POLICY "Approved employees update own attendance" ON public.attendance 
  FOR UPDATE USING (auth.uid() = user_id);

-- 4. Location Logs Policies
CREATE POLICY "Employees view own location logs" ON public.location_logs 
  FOR SELECT USING (auth.uid() = user_id OR public.is_admin());

CREATE POLICY "Employees insert own location logs" ON public.location_logs 
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 5. Salary Settings Policies
CREATE POLICY "Employees view own salary setting" ON public.salary_settings 
  FOR SELECT USING (auth.uid() = user_id OR public.is_admin());

CREATE POLICY "Admins modify salary settings" ON public.salary_settings 
  FOR ALL USING (public.is_admin());

-- 6. Salary Payments Policies
CREATE POLICY "Employees view own salary payments" ON public.salary_payments 
  FOR SELECT USING (auth.uid() = user_id OR public.is_admin());

CREATE POLICY "Admins manage salary payments" ON public.salary_payments 
  FOR ALL USING (public.is_admin());

-- 7. Admin Audit Logs Policies
CREATE POLICY "Admins view audit logs" ON public.admin_audit_logs 
  FOR SELECT USING (public.is_admin());

CREATE POLICY "Admins write audit logs" ON public.admin_audit_logs 
  FOR INSERT WITH CHECK (public.is_admin());