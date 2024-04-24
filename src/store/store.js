import Vuex from 'vuex';
import Vue from 'vue';
import createPersistedState from 'vuex-persistedstate'

Vue.use(Vuex);

const store = new Vuex.Store({
    plugins: [createPersistedState({ storage: window.sessionStorage })],
    state: {
        token: null,
        Servertoken:null,
        user: null,
        server:null,
        isUserLoggedIn: false,
        isServerLoggedIn:false
        },

        mutations: {
        setToken (state, token) {
            state.token = token
            state.isUserLoggedIn = token && state.token === 200;
        },
        setServerToken (state, token) {
            state.Servertoken = token
            state.isServerLoggedIn = token && state.Servertoken === 200;
        }
        },

        actions: {
            setToken ({ commit }, token) {
                commit('setToken', token)
            },
            setServerToken({commit},token){
                commit('setServerToken', token)
            }
    }
});
export default store;