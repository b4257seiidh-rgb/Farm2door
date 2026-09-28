# Farm2Door

A responsive fresh-produce marketplace connecting customers with nearby farmers. The local version uses HTML, CSS, Bootstrap, vanilla JavaScript, Express, and a persistent SQLite database. No AWS account or credentials are needed to run it.

## Run locally

Requirements: Node.js 20 or newer and npm.

```powershell
npm install
Copy-Item .env.example .env
```

Set `JWT_SECRET` in `.env` to a long, private random value before using the app beyond a local demonstration. Then start the server:

```powershell
npm run dev
```

Open http://localhost:3000. On Windows, you can also double-click `start.bat`; keep its terminal window open while using the website. Do not open `h.html` directly from File Explorer: the app needs the Express server for its API and local assets. The first start creates `data/farm2door.sqlite` and adds a modest set of sample farms and produce listings. Sample farmer records are browse-only; create a farmer account from **Grow with us** to manage listings and orders.

Create the first administrator with a unique email and a private password of at least 12 characters:

```powershell
npm run create-admin -- "Farm2Door Admin" admin@example.com "use-a-private-password"
```

Then sign in at `http://localhost:3000/#admin-login`. Do not use the example password above as an actual credential.

## Included flows

- Customer registration and sign-in, product search and filters, product details, cart, checkout, order history, tracking, notifications, cancellation, and ratings after delivery.
- Farmer registration and sign-in, farm profile, image upload, produce listing management, order visibility, status updates, and sales overview.
- Admin sign-in, marketplace overview, account suspension/reactivation, product removal, and order monitoring/status updates.
- API validation, password hashing, signed sessions, role authorization, security headers, request limits, and transactional order/stock updates.

## Project structure

```text
server.js                  Express startup
src/app.js                 HTTP middleware and route mounting
src/config/                Environment and AWS configuration
src/db/schema.sql          Relational schema
src/db/seed.js             Repeatable local sample data
src/controllers/           Request handlers
src/routes/                Feature and role routes
src/middleware/            Authentication, validation boundary, errors
src/services/              Local storage and notification adapters
public/css/style.css       Responsive visual system
public/js/app.js           Browser application and API client
h.html                     App entry point
```

## API overview

- `POST /api/auth/register`, `POST /api/auth/login`, `GET /api/auth/me`
- `GET /api/products`, `GET /api/products/:id`, farmer-managed product CRUD
- `POST /api/orders`, customer order history and tracking, farmer order status updates
- `/api/customers`, `/api/farmers`, `/api/admin`, `/api/notifications`, `/api/ratings`
- `GET /api/health`

All protected API requests use `Authorization: Bearer <token>`. API errors return a JSON `error` message.

## AWS integration points

The local app deliberately selects local adapters by default. The variables in `.env.example` reserve configuration names for AWS services; the local implementation does not call AWS and does not need AWS credentials.

- **RDS:** `src/db/index.js` is the database boundary and `src/db/schema.sql` documents relationships. A production PostgreSQL adapter can replace the local SQLite adapter while preserving the route/controller boundary; use migrations compatible with PostgreSQL before deploying.
- **S3:** `src/services/imageStorage.js` is the image boundary. Local uploads are stored under `public/uploads`; replace the provider there with an S3 adapter and an EC2 instance role.
- **Cognito:** local password hashing and JWT issuance live in `src/controllers/authController.js`. Replace token verification and account operations behind that boundary with Cognito before production.
- **SNS:** `src/services/notifications.js` persists local in-app updates. Add SNS publishing there for SMS/email delivery.
- **CloudWatch:** request logging is currently handled by Morgan and the console. Add a CloudWatch transport in the logging service when deployed.
- **IAM:** attach least-privilege permissions to the EC2 instance role for the selected S3 bucket, SNS topic, and CloudWatch log group. Never put AWS keys in source or `.env` on EC2.

The SQLite schema is a local demonstration schema, not an AWS RDS migration. Production deployment should add PostgreSQL migrations, HTTPS, backups, managed secrets, and additional operational controls.