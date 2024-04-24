import SignIn from '../views/SignIn.vue'
import RegisterName from '../views/Register.vue'
import AdminPage from '../views/Admin.vue'
import ClientPage from '../views/Client.vue'
import ServerLogin from '../views/ServerLogin.vue'
import ServerPage from '../views/ServerPage.vue'

import Vue from 'vue';
import Router from 'vue-router';
import store from '../store/store'


Vue.use(Router)


const routes = [
    {
        path: "/",
        redirect: SignIn
    },
    {
        name: "SignIn",
        component: SignIn,
        path: "/admin/signin",
    },
    {
        name: "RegisterName",
        component: RegisterName,
        path: "/admin/register",
    },
    {
        name: "AdminPage",
        component: AdminPage,
        path: "/admin",
    },

    {
        name: "ClientPage",
        component: ClientPage,
        path: "/:id/client/:table",
    },
    {
        name:"ServerLogin",
        component: ServerLogin,
        path:"/server/signin/:id"
    },
    {
        name:"ServerPage",
        component:ServerPage,
        path:"/:id/server"
    }

];

const router = new Router({
    mode: 'history',
    routes,
})

router.beforeEach((to, from, next) => {
    console.log(store.state.isServerLoggedIn);
    // console.log(to.fullPath)
    if (to.fullPath === '/admin' && store.state.isUserLoggedIn === false) {
        next('/signin');
    }

    else if ((to.fullPath === '/register' || to.fullPath === '/signin') && store.state.isUserLoggedIn === true) {
        next('/admin');
    }

    else if (to.name === 'ServerPage' && store.state.isServerLoggedIn === false) {
        next({name:"ServerLogin"});
    }

    else if (to.name === 'ServerLogin' && store.state.isServerLoggedIn === true) {
        next({name:"ServerPage"});
    }

    else {
        next();
    }

});


export default router;