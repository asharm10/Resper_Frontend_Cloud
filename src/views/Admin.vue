<template>
  <v-app id="inspire">
    <v-app-bar color="error" class="flex-grow-0" app dark>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
      <v-spacer />
      <v-toolbar-title class="nav-title">RESPER</v-toolbar-title>
      <v-spacer />
    </v-app-bar>
    <v-navigation-drawer v-model="drawer" app class="pt-4" color="grey lighten-3">
      <v-list>
        <v-list-item v-for="([icon, text], i) in items" :key="i" link @click="changeComponent(i)">
          <v-list-item-icon>
            <v-icon>{{ icon }}</v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>{{ text }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
      <template v-slot:append>
        <div class="pa-2">

          <v-dialog v-model="dialog" width="500">
            <template v-slot:activator="{ on, attrs }">
              <v-btn color="red" dark v-bind="attrs" v-on="on">
                Log Out
              </v-btn>
            </template>

            <v-card>
              <v-card-title class="text-h5 grey lighten-2">
                LOGOUT
              </v-card-title>

              <v-card-text>
                Are you sure you want to Logout?
              </v-card-text>

              <v-divider></v-divider>

              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="primary" text @click="logout">
                  Yes
                </v-btn>
                <v-btn color="primary" text @click="dialog = false">
                  No
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
        </div>
      </template>
    </v-navigation-drawer>

    <v-main class="grey lighten-3 mt-10">
      <v-container>
        <v-row>

          <v-col cols="12" sm="8">
            <ServerList v-if="currentIndex === 0" />
            <InformationEdit v-else-if="currentIndex === 1" />
            <Feedbacks v-else-if="currentIndex === 2" />
            <ServerQRComponent v-else-if="currentIndex === 3" />
            <ClientQRComponent v-else-if="currentIndex === 4" />

          </v-col>
          <v-col cols="12" sm="3">
            <v-sheet rounded="lg" min-height="268">

              <v-layout align-center justify-center>
                <v-card class="elevation-0">
                  <v-card-title>
                    <center>
                      Add a new Server
                    </center>
                  </v-card-title>
                  <v-card-text>
                    <v-form @submit.prevent="register">
                      <v-text-field name="Full Name" v-model="fullname" label="Full Name" type="text"></v-text-field>
                      <v-text-field name="username" v-model="username" label="Username" type="text"></v-text-field>
                      <v-text-field id="password" name="password" v-model="password" label="Password" type="password">
                      </v-text-field>
                      <v-card-actions>
                        <v-col>
                          <v-btn type="submit" class="mb-5" block color="error">Add Server</v-btn>
                        </v-col>
                      </v-card-actions>
                    </v-form>
                  </v-card-text>
                </v-card>
              </v-layout>
            </v-sheet>
          </v-col>
        </v-row>
        <v-snackbar v-model="snackbar">
          {{ snackbarText }}

          <template v-slot:action="{ attrs }">
            <v-btn color="pink" text v-bind="attrs" @click="snackbar = false">
              Close
            </v-btn>
          </template>
        </v-snackbar>
      </v-container>
    </v-main>
  </v-app>
</template>
 
<script>
import ServerList from "../components/ServerList.vue";
import InformationEdit from "../components/InformationEdit.vue";
import Feedbacks from "../components/Feedbacks.vue";
import ServerQRComponent from "../components/ServerQRComponent.vue";
import ClientQRComponent from "../components/ClientQRComponent.vue";

export default {
  name: "AdminPage",
  data() {
    return {
      selected: [2],
      dialog: false,
      counter: 0,
      drawer: false,
      username: '',
      fullname: '',
      snackbar: false,
      snackbarText: '',
      password: '',
      currentIndex: 0,
      items: [
        ["mdi-group", "Server Information"],
        ["mdi-domain", "Restaurant Information"],
        ["mdi-star", "View Feedback"],
        ["mdi-head", "Server Login URL"],
        ["mdi-cart", "Client Page URL"]
      ]
    };
  },
  methods: {
    logout(e) {
      e.preventDefault();
      if (localStorage.getItem('restaurantID')) {
        localStorage.removeItem('restaurantID');
      }
      this.dialog = false;
      this.$store.dispatch("setToken", 403);
      this.$router.back();
    },
    changeComponent(i) {
      this.currentIndex = i;
      this.drawer = false;
    },
    async register() {
      this.snackbar = false;
      const { fullname, username, password } = this;
      if (!(fullname && username && password)) {
        this.snackbarText = "Error - Fields cannot be empty";
        this.snackbar = true;
        return;
      }
      const res = await fetch(process.env.VUE_APP_BACKEND_URL + "admin/servers", {
        method: "POST",
        credentials: "include",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          fullname,
          username,
          password
        })
      });
      const data = await res.json();
      if (data.status === 200) {
        this.$root.$refs.ServerList.getServers();
        this.snackbarText = "Successfully added a new server";
        this.snackbar = true;
      }
      else {
        this.snackbarText = "Error - Could not add the server";
        this.snackbar = true;
      }
      console.log(data);
      // if (data.status == 200){
      //     this.$store.dispatch('setToken', res.status)
      //     this.$router.push("/admin");
      // }
    },
  },
  components: { ServerList, InformationEdit, Feedbacks, ServerQRComponent, ClientQRComponent }
}
</script>
