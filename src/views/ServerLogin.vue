<template>
  <v-app id="inspire">

    <v-content>
      <Navbar />
      <v-container mt-10>
        <v-layout align-center justify-center>

          <v-flex xs12 sm8 md4>
            <v-card class="elevation-12">
              <v-card-title>
                Server Sign In
              </v-card-title>
              <v-card-text>
                <v-form @submit.prevent="signIn">
                  <v-text-field name="username" v-model="username" label="Username" type="text"></v-text-field>
                  <v-text-field id="password" name="password" v-model="password" label="Password" type="password">
                  </v-text-field>
                  <v-card-actions>
                    <v-col>
                      <v-btn type="submit" class="mb-5" block color="error">Login</v-btn>
                    </v-col>
                  </v-card-actions>
                </v-form>
              </v-card-text>
            </v-card>
          </v-flex>
        </v-layout>
      </v-container>
    </v-content>

  </v-app>
</template>

<script>
import Navbar from "../components/Navbar.vue";
export default {
  name: "ServerLogin",
  data() {
    return {
      restaurantID: this.$route.params.id,
      username: "",
      password: "",
    };
  },
  created() {
    localStorage.setItem('resturantID', this.restaurantID)
  }
  ,
  methods: {
    async signIn() {
      const { username, password } = this;
      const res = await fetch(process.env.VUE_APP_BACKEND_URL + this.restaurantID + "/server/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        credentials: "include",
        body: JSON.stringify({
          username,
          password
        })
      });
      const data = await res.json();
      console.log(data);
      if (data.status == 200) {
        localStorage.setItem('username', data.success.username);
        localStorage.setItem('fullname', data.success.fullname);
        localStorage.setItem('token', data.token);
        this.$store.dispatch("setServerToken", res.status);
        console.log(res.status)
        this.$router.push("/" + this.restaurantID + "/server");
      }
      else {
        alert("Invalid credentials");
      }
    }
  },
  components: { Navbar }
};
</script>
