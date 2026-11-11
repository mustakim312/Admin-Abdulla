const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

const authContainer = document.getElementById('auth-container');
const dashboardContainer = document.getElementById('dashboard-container');
const loginForm = document.getElementById('login-form');
const errorMsg = document.getElementById('error-msg');
const logoutBtn = document.getElementById('logout-btn');

loginForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    const { data, error } = await supabaseClient.auth.signInWithPassword({ email, password });
    if (error) {
        errorMsg.textContent = error.message;
        return;
    }

    // Verify if user is admin
    const { data: profile, error: profileError } = await supabaseClient
        .from('profiles')
        .select('role, status')
        .eq('id', data.user.id)
        .single();

    if (profileError || profile.role !== 'admin' || profile.status !== 'approved') {
        errorMsg.textContent = 'Access denied. Administrator privileges required.';
        await supabaseClient.auth.signOut();
        return;
    }

    loadDashboard();
});

logoutBtn.addEventListener('click', async () => {
    await supabaseClient.auth.signOut();
    dashboardContainer.classList.add('hidden');
    authContainer.classList.remove('hidden');
});

async function loadDashboard() {
    authContainer.classList.add('hidden');
    dashboardContainer.classList.remove('hidden');

    // Fetch Total Employees
    const { count: totalCount } = await supabaseClient.from('profiles').select('*', { count: 'exact', head: true });
    document.getElementById('total-employees').textContent = totalCount || 0;

    // Fetch Active Employees
    const { count: activeCount } = await supabaseClient.from('profiles').select('*', { count: 'exact', head: true }).eq('is_online', true);
    document.getElementById('active-employees').textContent = activeCount || 0;

    // Fetch Pending Users
    const { data: pendingUsers } = await supabaseClient.from('profiles').select('*').eq('status', 'pending');
    const tbody = document.getElementById('pending-users-list');
    tbody.innerHTML = '';

    if (pendingUsers) {
        pendingUsers.forEach(user => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${user.email}</td>
                <td>${user.status}</td>
                <td><button class="approve-btn" onclick="approveUser('${user.id}')">Approve</button></td>
            `;
            tbody.appendChild(tr);
        });
    }
}

window.approveUser = async function(userId) {
    const { error } = await supabaseClient.from('profiles').update({ status: 'approved' }).eq('id', userId);
    if (!error) {
        alert('Employee approved successfully!');
        loadDashboard();
    } else {
        alert('Failed to approve user: ' + error.message);
    }
}